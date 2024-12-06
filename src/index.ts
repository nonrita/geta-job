import express from 'express';
import cors from 'cors';
const app: express.Express = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(cors());

app.listen(3001, () => {
  console.log('Start on port 3001.');
});

app.get('/users', (req: express.Request, res: express.Response) => {
  res.send('aaaa');
});
