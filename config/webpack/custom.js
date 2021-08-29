// Webpacker 6 uses "rules", no more "environment"

// const BundleAnalyzerPlugin =
//   require("webpack-bundle-analyzer").BundleAnalyzerPlugin;

module.exports = {
  resolve: {
    alias: {
      react: "preact/compat",
      "react-dom": "preact/compat",
    },
    extensions: ["css"],
  },
  // plugins: [
  //   new BundleAnalyzerPlugin(),
};
