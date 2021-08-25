const { webpackConfig, merge } = require("@rails/webpacker");
const customConfig = {
  resolve: {
    alias: {
      React: "react",
      ReactDOM: "react-dom",
    },
    extensions: ["css"],
  },
};
module.exports = merge(webpackConfig, customConfig);
