import { Router } from 'express';
import { trackProduct } from '../controllers/trackController';

const router = Router();

router.post('/', trackProduct);

export default router;
