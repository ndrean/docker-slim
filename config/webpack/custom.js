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
  // module: {
  //   rules: [
  //     // Use esbuild as a Babel alternative
  //     {
  //       test: /\.js$/,
  //       loader: "esbuild-loader",
  //       options: {
  //         target: "es2015",
  //       },
  //     },
  //   ],
  // },

  // plugins: [
  //   new BundleAnalyzerPlugin(),
  //   //   new DashboardPlugin({
  //   //     port: 3001,
  //   //   }),
  // ],
};
