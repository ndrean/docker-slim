process.env.NODE_ENV = process.env.NODE_ENV || "development";
const webpackConfig = require("./base");
// const { environment } = require("@rails/webpacker");
// console.log(require("@rails/webpacker"));
module.exports = webpackConfig;
