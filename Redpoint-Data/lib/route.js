// Class to get route data given a route page
const request = require('request-promise');
const cheerio = require('cheerio');

const baseUrl = 'https://www.mountainproject.com';

function parseParagraphs($, paragraphs) {
  const data = {};
  paragraphs.each((i, e) => {
    const header = $(e);
    const text = header.text().trim();
    if (text === 'Permit Required') data.permitInfo = $(e).next().text();
    if (text === 'Description') data.description = $(e).next().text();
    if (text === 'Location') data.location = $(e).next().text();
    if (text === 'Protection') data.protection = $(e).next().text();
  });
  return data;
}

function makeStringNotEmpty(data) {
  return (data === undefined) ? 'None' : data;
}

function getRouteNumber($) {
  const rawNumber = $('#leftNavRoutes').find('span[class=bold]').parent().parent().attr('poslr');
  return Number.parseInt(rawNumber, 10);
}

function gradeInt(grade) {
  let result = 999999;
  if (grade.startsWith('V')) {
    result = parseInt(/[0-9]+/.exec(grade)[0], 10) + 1000;
  } else {
    result = parseInt(grade.match(/[0-9]+/g)[1], 10) * 10;
    if (/a/.test(grade)) result += 2;
    if (/b/.test(grade)) result += 4;
    if (/c/.test(grade)) result += 6;
    if (/d/.test(grade)) result += 8;
    if (/-/.test(grade)) result -= 1;
    if (/\+/.test(grade)) result += 1;
  }
  return result;
}

class Route {
  constructor(page) {
    this.url = `${baseUrl}${page.url}`;
    this.id = page.page_id;
  }

  // Visits the url and retrieves the route data
  get() {
    if (this.url === undefined || this.url === '') return Promise.resolve(undefined);
    const data = {};
    return request(this.url).then((res) => {
      const $ = cheerio.load(res);
      // raw route info from info table on Mountain Project route page
      const info = $('#rspCol800 table tbody tr td').text().split(':');
      if (typeof info[1] === 'undefined') Promise.reject();
      const typeInfo = info[1].split(',');
      const paragraphs = $('h3.dkorange');
      data.name = $('h1.dkorange').text().trim();
      data.type = typeInfo[0].trim();
      // data.pitches = lengthInfo[1].trim();
      const matchLength = info[1].match(/[0-9]+?(?=')/g);
      data.length = (matchLength) ? Number.parseInt(matchLength[0], 10) : 0;
      data.grade = info[3].split(' ')[0].trim();
      data.stars = Number.parseFloat($('span#starSummaryText.small span').find('meta').attr('content'));
      data.number = getRouteNumber($);
      const paragraphData = parseParagraphs($, paragraphs);
      data.needs_permit = (typeof paragraphData.permitInfo === 'undefined') ? 0 : 1;
      data.permit_info = makeStringNotEmpty(paragraphData.permitInfo);
      data.grade_int = gradeInt(data.grade);
      data.description = makeStringNotEmpty(paragraphData.description);
      data.location = makeStringNotEmpty(paragraphData.location);
      data.protection = makeStringNotEmpty(paragraphData.protection);
      data.url = this.url;
      data.route_id = this.id;
      return data;
    });
  }
}

module.exports = Route;
