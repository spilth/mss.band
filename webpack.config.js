const webpack = require('webpack');

const isProduction = process.env.NODE_ENV === 'production';

const productionPlugins = [
    new webpack.DefinePlugin({
        'process.env.NODE_ENV': '"production"'
    })
];

module.exports = {
    mode: 'production',
    entry: './assets/javascripts/index.js',
    devtool: 'source-map',
    output: {
        library: 'MyApp',
        path: __dirname + '/tmp/dist',
        filename: 'bundle.js',
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                loader: 'babel-loader',
                exclude: /node_modules/
            }
        ]
    },
    plugins: isProduction ? productionPlugins : []
};
