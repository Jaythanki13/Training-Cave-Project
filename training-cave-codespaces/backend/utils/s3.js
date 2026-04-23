import AWS from 'aws-sdk';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Check if AWS credentials are configured
const useLocalStorage = !process.env.AWS_ACCESS_KEY_ID || !process.env.AWS_SECRET_ACCESS_KEY;

if (useLocalStorage) {
  console.log('⚠️  AWS credentials not found - using LOCAL file storage');
  console.log('📁 Files will be stored in /uploads directory');
  console.log('💡 Add AWS credentials to .env to use S3');
}

// Local storage directory
const UPLOAD_DIR = path.join(__dirname, '../../uploads');

// Ensure upload directory exists
if (useLocalStorage && !fs.existsSync(UPLOAD_DIR)) {
  fs.mkdirSync(UPLOAD_DIR, { recursive: true });
  console.log('📁 Created uploads directory:', UPLOAD_DIR);
}

// Configure AWS (only if credentials exist)
let s3;
if (!useLocalStorage) {
  AWS.config.update({
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    region: process.env.AWS_REGION,
  });
  s3 = new AWS.S3();
}

// Upload file (S3 or local)
export const uploadToS3 = async (file, folder = 'materials') => {
  try {
    const fileExtension = path.extname(file.originalname);
    const fileName = `${folder}/${Date.now()}-${Math.random().toString(36).substring(7)}${fileExtension}`;

    if (useLocalStorage) {
      // LOCAL STORAGE
      const folderPath = path.join(UPLOAD_DIR, folder);
      if (!fs.existsSync(folderPath)) {
        fs.mkdirSync(folderPath, { recursive: true });
      }
      
      const filePath = path.join(UPLOAD_DIR, fileName);
      fs.writeFileSync(filePath, file.buffer);
      
      return {
        url: `/uploads/${fileName}`,
        key: fileName,
        bucket: 'local',
      };
    } else {
      // S3 STORAGE
      const params = {
        Bucket: process.env.AWS_S3_BUCKET,
        Key: fileName,
        Body: file.buffer,
        ContentType: file.mimetype,
        ACL: 'private',
      };

      const result = await s3.upload(params).promise();
      
      return {
        url: result.Location,
        key: result.Key,
        bucket: result.Bucket,
      };
    }
  } catch (error) {
    console.error('❌ Upload error:', error);
    throw new Error('File upload failed');
  }
};

// Delete file (S3 or local)
export const deleteFromS3 = async (fileKey) => {
  try {
    if (useLocalStorage) {
      // LOCAL STORAGE
      const filePath = path.join(UPLOAD_DIR, fileKey);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
        console.log('🗑️  File deleted from local storage:', fileKey);
      }
    } else {
      // S3 STORAGE
      const params = {
        Bucket: process.env.AWS_S3_BUCKET,
        Key: fileKey,
      };

      await s3.deleteObject(params).promise();
      console.log('🗑️  File deleted from S3:', fileKey);
    }
  } catch (error) {
    console.error('❌ Delete error:', error);
    throw new Error('File deletion failed');
  }
};

// Get download URL (S3 signed URL or local path)
export const getSignedUrl = async (fileKey) => {
  try {
    if (useLocalStorage) {
      // LOCAL STORAGE - return direct path
      return `/uploads/${fileKey}`;
    } else {
      // S3 STORAGE - generate signed URL
      const params = {
        Bucket: process.env.AWS_S3_BUCKET,
        Key: fileKey,
        Expires: 3600,
      };

      const url = await s3.getSignedUrlPromise('getObject', params);
      return url;
    }
  } catch (error) {
    console.error('❌ Signed URL error:', error);
    throw new Error('Failed to generate download URL');
  }
};

// Validate file before upload
export const validateFile = (file) => {
  const MAX_SIZE = parseInt(process.env.MAX_FILE_SIZE) || 1073741824;

  if (file.size > MAX_SIZE) {
    throw new Error(`File size exceeds maximum allowed (${MAX_SIZE / (1024 * 1024)}MB)`);
  }

  const allowedTypes = [
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'video/mp4',
    'video/avi',
    'video/quicktime',
    'audio/mpeg',
    'audio/mp3',
    'application/zip',
    'application/x-zip-compressed',
    'application/json',
    'text/csv',
    'text/plain',
    'application/sql',
    'text/x-python',
    'text/javascript',
    'text/x-java-source',
  ];

  if (!allowedTypes.includes(file.mimetype)) {
    throw new Error('File type not allowed');
  }

  return true;
};

export default { uploadToS3, deleteFromS3, getSignedUrl, validateFile };
