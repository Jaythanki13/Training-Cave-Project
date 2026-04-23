# 🗿 TRAINING CAVE - GITHUB CODESPACES SETUP GUIDE

## Complete Step-by-Step Guide for Running Training Cave in Your Browser!

**NO INSTALLATION ON YOUR LAPTOP NEEDED!**

Everything runs in the cloud. Works on company laptop, old laptop, ANY computer!

---

## 📋 WHAT YOU NEED

1. **GitHub Account** (Free)
2. **Web Browser** (Chrome, Edge, Firefox, Safari)
3. **Internet Connection**

That's it! No admin rights, no installations!

---

## 🚀 STEP-BY-STEP SETUP (30 Minutes)

### PART 1: CREATE GITHUB ACCOUNT (5 minutes)

1. Go to: https://github.com
2. Click "Sign up"
3. Enter email: (use your personal email)
4. Create password
5. Choose username
6. Verify email
7. ✅ Done!

---

### PART 2: UPLOAD CODE TO GITHUB (10 minutes)

#### Option A: Using GitHub Web Interface (Easiest!)

1. **Login to GitHub**
   - Go to https://github.com
   - Click "Sign in"

2. **Create New Repository**
   - Click "+" icon (top right)
   - Select "New repository"
   - Name: `training-cave`
   - Description: "Training platform for learners and trainers"
   - Keep it **Private** (recommended)
   - ✅ Don't check "Initialize with README"
   - Click "Create repository"

3. **Upload Files**
   - You'll see "uploading an existing file" link
   - Click it
   - **Drag and drop** the extracted `training-cave-codespaces` folder
   - Or click "choose your files" and select all files
   - Scroll down, click "Commit changes"

4. **Wait for Upload**
   - GitHub will process files (1-2 minutes)
   - ✅ Done!

---

### PART 3: LAUNCH CODESPACE (5 minutes)

1. **Open Your Repository**
   - Go to: https://github.com/YOUR_USERNAME/training-cave
   - You should see all your files

2. **Create Codespace**
   - Click green "Code" button
   - Click "Codespaces" tab
   - Click "Create codespace on main"
   
3. **Wait for Setup**
   - Codespace will open (looks like VS Code!)
   - Setup script runs automatically (3-5 minutes)
   - Watch the terminal - it will say:
     ```
     🗿 CAVEMAN SETTING UP TRAINING CAVE...
     📦 Installing frontend dependencies...
     📦 Installing backend dependencies...
     🗄️ Setting up PostgreSQL...
     ✅ Setup complete!
     ```

4. **Setup Complete!**
   - You now have a full development environment IN YOUR BROWSER!
   - ✅ Node.js installed
   - ✅ PostgreSQL installed
   - ✅ All dependencies installed
   - ✅ Database created

---

### PART 4: RUN THE PLATFORM (10 minutes)

#### Start Backend

1. **Open Terminal**
   - In Codespace, press `` Ctrl + ` `` (backtick)
   - Or: Menu → Terminal → New Terminal

2. **Navigate to Backend**
   ```bash
   cd backend
   ```

3. **Start Backend Server**
   ```bash
   npm run dev
   ```

4. **You'll See:**
   ```
   ═══════════════════════════════════════════
   🗿 TRAINING CAVE BACKEND
   ═══════════════════════════════════════════
   🚀 Server running on port 5000
   ✅ Connected to PostgreSQL database
   ⚠️  AWS credentials not found - using LOCAL file storage
   ```

5. **Backend is Running!**
   - Codespaces will show popup: "Your application running on port 5000 is available"
   - Click "Open in Browser" to test API
   - You should see: `{"status":"OK","timestamp":"..."}`

#### Start Frontend

1. **Open Second Terminal**
   - Click "+" icon in terminal panel
   - Or: `` Ctrl + Shift + ` ``

2. **Navigate to Frontend**
   ```bash
   cd frontend
   ```

3. **Start Frontend**
   ```bash
   npm run dev
   ```

4. **You'll See:**
   ```
   VITE v5.1.4  ready in 1234 ms
   
   ➜  Local:   http://localhost:3000/
   ➜  Network: use --host to expose
   ```

5. **Frontend is Running!**
   - Codespaces will show popup: "Your application running on port 3000 is available"
   - Click "Open in Browser"
   - **TRAINING CAVE OPENS IN NEW TAB!** 🎉

---

## 🎯 USING THE PLATFORM

### Testing Everything

1. **Landing Page** ✅
   - Opens automatically
   - See beautiful design
   - Click "Get Started"

2. **Sign Up as Learner** ✅
   - Click "Sign up"
   - Enter:
     - Name: Test Learner
     - Email: learner@test.com
     - Password: test123
     - Role: Learner
   - Click "Create Account"
   - ✅ You're logged in!

3. **Browse Materials** ✅
   - See materials page (currently empty)
   - Search works
   - Filters work
   - Everything responsive!

4. **Sign Up as Trainer** ✅
   - Logout
   - Sign up again:
     - Name: Test Trainer
     - Email: trainer@test.com
     - Password: test123
     - Role: Trainer
     - Bio: "Expert trainer"
     - Expertise: "Leadership, Communication"
   - Submit
   - ✅ Message: "Pending approval"
   - **Email sent to console** (check backend terminal!)

5. **Admin Login** ✅
   - Login as:
     - Email: jay.thanki@cognixia.com
     - Password: admin123
   - Go to: `http://your-codespace-url-3000/admin`
   - ✅ See pending trainers
   - Click "Approve"
   - Trainer can now login!

6. **Upload Materials** (Trainer) ✅
   - Login as approved trainer
   - Click "Upload Material"
   - Fill form:
     - Title: "Test Training"
     - Description: "Test material"
     - Category: Soft Skills
     - Training Date: Today
     - Type: Delivered
     - File: Any PDF/DOCX
   - Submit
   - ✅ File uploaded to `/uploads` folder
   - Learners can now see and download!

---

## 🔧 TROUBLESHOOTING

### Terminal Shows Errors

**Problem:** "npm: command not found"
**Solution:** Wait 2 more minutes - setup still running

**Problem:** "Database connection failed"
**Solution:** 
```bash
sudo service postgresql start
```

**Problem:** "Port 5000 already in use"
**Solution:**
```bash
# Kill old process
pkill -f "node.*server.js"
# Start again
npm run dev
```

### Codespace Won't Start

**Problem:** Stuck on "Creating codespace..."
**Solution:**
- Wait 5 minutes
- If still stuck, refresh page
- Delete codespace and create new one

### Files Not Uploading

**Problem:** "File upload failed"
**Solution:** This is normal! You're using local storage (no AWS yet)
- Files save to `/backend/uploads/` folder
- Check backend terminal - you'll see file path
- To use real S3, add AWS credentials to `.env`

### Can't Access URLs

**Problem:** Codespace URLs not working
**Solution:**
- Check "PORTS" tab in Codespace
- Click globe icon next to port 3000 (frontend)
- Click globe icon next to port 5000 (backend)
- Copy URLs manually

---

## 💡 PRO TIPS

### Keep Codespace Running
- Codespaces stop after 30 minutes of inactivity
- Just refresh page to restart
- All your code is saved!

### Share Your Work
- Click "Share" in Codespace
- Send link to others
- They can see your running app!

### Edit Code
- Click any file to edit
- Changes auto-save
- Backend/Frontend auto-reload
- It's like having your own cloud computer!

### View Logs
- Backend logs: Check backend terminal
- Frontend logs: Press F12 → Console tab
- Database: 
  ```bash
  sudo -u postgres psql training_cave
  SELECT * FROM users;
  \q
  ```

---

## 📧 ADDING EMAIL (OPTIONAL)

To receive real emails (trainer approvals, etc):

1. **Get Gmail App Password**
   - Go to: https://myaccount.google.com
   - Security → 2-Step Verification → App passwords
   - Generate password for "Mail"
   - Copy 16-character code

2. **Update .env**
   - Open `backend/.env` in Codespace
   - Find:
     ```
     EMAIL_USER=
     EMAIL_PASSWORD=
     ```
   - Change to:
     ```
     EMAIL_USER=your-email@gmail.com
     EMAIL_PASSWORD=your-16-char-app-password
     ```

3. **Restart Backend**
   - In backend terminal: Press `Ctrl+C`
   - Run: `npm run dev`

4. **Test!**
   - Approve a trainer
   - Real email sent! 📧

---

## ☁️ ADDING AWS S3 (OPTIONAL)

To store files in cloud instead of local:

1. **Create AWS Account**
   - Go to: https://aws.amazon.com
   - Sign up (free tier available)

2. **Create S3 Bucket**
   - AWS Console → S3
   - Create bucket
   - Name: `training-cave-files`
   - Region: US East (N. Virginia)
   - Keep all defaults
   - Create

3. **Get Access Keys**
   - AWS Console → IAM
   - Users → Create user
   - Attach policy: "AmazonS3FullAccess"
   - Create access key
   - Copy Access Key ID and Secret

4. **Update .env**
   - Open `backend/.env`
   - Find:
     ```
     AWS_ACCESS_KEY_ID=
     AWS_SECRET_ACCESS_KEY=
     AWS_S3_BUCKET=
     ```
   - Fill in your values

5. **Restart Backend**
   - Backend will now use S3!
   - Files uploaded to cloud
   - Can handle HUGE files

---

## 🎓 LEARNING THE CODE

### Explore Files
```
training-cave/
├── frontend/          ← React app
│   ├── src/
│   │   ├── pages/    ← All 4 pages here!
│   │   └── App.jsx   ← Routes
│   └── package.json
│
├── backend/           ← API server
│   ├── controllers/  ← Logic (auth, materials, admin)
│   ├── routes/       ← API endpoints
│   ├── utils/        ← Helpers (email, S3)
│   └── src/server.js ← Main file
│
└── database-schema.sql ← Database structure
```

### Make Changes
- Edit any file
- Save
- See changes instantly!
- It's YOUR platform now!

---

## 💰 CODESPACES COSTS

**Free Tier:**
- 60 hours/month FREE
- 15GB storage
- Perfect for development!

**After Free Tier:**
- $0.18/hour for active use
- Stops when inactive
- Still very affordable!

**Example Usage:**
- 2 hours/day × 20 days = 40 hours/month
- ✅ STILL FREE!

---

## 🚀 NEXT STEPS

### Week 1: Learn & Test
- Play with all features
- Sign up users
- Upload materials
- Approve trainers
- Break things! (it's okay!)

### Week 2: Customize
- Change colors in frontend
- Add new categories
- Modify email templates
- Make it yours!

### Week 3: Add Services
- Connect AWS S3
- Add Gmail
- Test with real trainers

### Week 4: Deploy Live
- Export from Codespace
- Deploy to Vercel (frontend)
- Deploy to Railway (backend)
- **GO LIVE!** 🎉

---

## 📞 HELP & SUPPORT

**Something not working?**
1. Check terminal for errors
2. Read error message carefully
3. Google the error
4. Ask caveman! 🗿

**Want to stop for the day?**
1. Press Ctrl+C in both terminals
2. Close Codespace tab
3. Everything is saved!
4. Come back anytime!

**Want to delete everything?**
1. Go to GitHub repo
2. Settings → Danger Zone
3. Delete repository
4. Start fresh!

---

## ✅ SUCCESS CHECKLIST

After setup, you should have:
- ✅ Codespace running
- ✅ Backend on port 5000
- ✅ Frontend on port 3000
- ✅ Database with tables
- ✅ Can sign up users
- ✅ Can upload materials (locally)
- ✅ Can approve trainers
- ✅ All 4 pages working

**If all checked → YOU DID IT!** 🎉🗿

---

## 🎯 FINAL NOTES

**You now have:**
- Full training platform
- In the cloud
- No laptop installations
- Professional development environment
- Version control (Git)
- Can work from anywhere!

**This is REAL development!**
- Same tools professional developers use
- Same workflow
- You're learning while building!

**Caveman proud of you!** 🦴💪

---

**Contact:** jay.thanki@cognixia.com

**Built with 🗿 by Caveman**
