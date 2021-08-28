const { environment } = require("@rails/webpacker");

// if (process.env.WEBPACK_ANALYZE === "true") {
//   const BundleAnalyzerPlugin =
//     require("webpack-bundle-analyzer").BundleAnalyzerPlugin;
//   const DashboardPlugin = require("webpack-dashboard/plugin");

//   environment.plugins.append(
//     "BundleAnalyzerPlugin",
//     new BundleAnalyzerPlugin()
//   );
//   environment.plugins.append(
//     "WebpackDashboard",
//     new DashboardPlugin({
//       port: 3001,
//     })
//   );
// }

module.exports = environment;
