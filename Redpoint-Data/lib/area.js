// class to get area info given an area page
const request = require('request-promise');
const cheerio = require('cheerio');

const baseUrl = 'https://www.mountainproject.com';

function getDescription($) {
  let description;
  $('h2').each((i, e) => {
    const text = $(e).text().trim();
    if (text === 'Description') {
      const rawText = $(e).parent().text();
      const offset = rawText.search('Description');
      description = rawText.substring(offset + 11, rawText.length - 1);
    }
  });
  return description;
}

class Area {
  constructor(page) {
    this.url = `${baseUrl}${page.url}`;
    this.area_id = page.page_id;
  }

  get() {
    if (this.url === undefined || this.url === '') return Promise.resolve(undefined);
    const data = {};
    return request(this.url).then((res) => {
      const $ = cheerio.load(res);
      // Cleanup
      $('.hidden-md-down').remove();
      // Scrape
      data.name = $('h1').text().trim();
      data.description = getDescription($);
      data.location = getLocation($);
      return data;
    });
  }
}

module.exports = Area;
