import listEndpoints from 'express-list-endpoints';
import chalk from 'chalk';
import { Express } from 'express';

const printEndpoints = (app: Express) => {
  const endpoints = listEndpoints(app);
  endpoints.forEach((endpoint) => {
    console.log(
      chalk.green(endpoint.path) +
        ':' +
        chalk.blue(` [ ${endpoint.methods.join(', ')} ]`)
    );
  });
};

export { printEndpoints };
