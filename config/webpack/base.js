const { webpackConfig, merge } = require("@rails/webpacker");

const customConfig = require("./custom.js");

module.exports = merge(webpackConfig, customConfig);
