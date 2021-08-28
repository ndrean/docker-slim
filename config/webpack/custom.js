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
  //   //   new DashboardPlugin({
  //   //     port: 3001,
  //   //   }),
  // ],
};
