import express from 'express';
import {
  getPendingTrainers,
  approveTrainer,
  rejectTrainer,
  getAllUsers,
  banUser,
  unbanUser,
  getStats,
  getAllMaterials
} from '../controllers/adminController.js';
import { authenticate, authorize } from '../middleware/auth.js';

const router = express.Router();

// All admin routes require super_admin role
router.use(authenticate, authorize('super_admin'));

// Trainer management
router.get('/trainers/pending', getPendingTrainers);
router.post('/trainers/:id/approve', approveTrainer);
router.post('/trainers/:id/reject', rejectTrainer);

// User management
router.get('/users', getAllUsers);
router.post('/users/:id/ban', banUser);
router.post('/users/:id/unban', unbanUser);

// Platform statistics
router.get('/stats', getStats);

// Materials management
router.get('/materials', getAllMaterials);

export default router;
