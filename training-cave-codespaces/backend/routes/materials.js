import express from 'express';
import multer from 'multer';
import {
  uploadMaterial,
  getMaterials,
  getMaterialById,
  downloadMaterial,
  getMyMaterials,
  updateMaterial,
  deleteMaterial,
  getCategories
} from '../controllers/materialsController.js';
import { authenticate, authorize, optionalAuth } from '../middleware/auth.js';

const router = express.Router();

// Configure multer for file upload (memory storage)
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: parseInt(process.env.MAX_FILE_SIZE) || 1073741824, // 1GB
  },
});

// Public routes
router.get('/', optionalAuth, getMaterials);
router.get('/categories', getCategories);
router.get('/:id', optionalAuth, getMaterialById);
router.get('/:id/download', optionalAuth, downloadMaterial);

// Trainer routes
router.post('/', authenticate, authorize('trainer'), upload.single('file'), uploadMaterial);
router.get('/my/materials', authenticate, authorize('trainer'), getMyMaterials);
router.put('/:id', authenticate, authorize('trainer'), updateMaterial);
router.delete('/:id', authenticate, authorize('trainer', 'super_admin'), deleteMaterial);

export default router;
