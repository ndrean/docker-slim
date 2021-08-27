const { merge, webpackConfig } = require("@rails/webpacker");
const customConfig = require("./custom.js");
module.exports = merge(customConfig, webpackConfig);
