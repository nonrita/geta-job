import express from 'express';
import cors from 'cors';
import router from './router';
import { printEndpoints } from './util/printEndpoints';

const app: express.Express = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(router);

app.listen(3001, () => {
  console.log('Start on port 3001.');
  printEndpoints(app);
});
