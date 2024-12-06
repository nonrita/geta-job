import express, { Request, Response } from 'express';

const router = express.Router();

router.get('/', (req: Request, res: Response) => {
  res.status(201).json({
    message: 'test success',
  });
});

export default router;
