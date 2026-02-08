# TaskNet - Web Browser Guide

TaskNet is now configured to run on **any modern web browser**. This guide shows you how to run it on Chrome, Edge, Firefox, Safari, Opera, Brave, and more.

---

## 🚀 Quick Start (Works on ALL Browsers)

### Method 1: Using Python HTTP Server (Recommended)

1. Build the web app (if not already built):
   ```bash
   flutter build web --release
   ```

2. Start a local web server:
   ```bash
   cd build/web
   python -m http.server 8080
   ```

3. Open **ANY** of these browsers and navigate to:
   ```
   http://localhost:8080
   ```

   **Supported Browsers:**
   - ✅ Google Chrome
   - ✅ Microsoft Edge
   - ✅ Mozilla Firefox
   - ✅ Safari
   - ✅ Opera
   - ✅ Brave
   - ✅ Vivaldi
   - ✅ Any Chromium-based browser

---

## 🌐 Method 2: Using Flutter Run (Browser-Specific)

### Chrome
```bash
flutter run -d chrome --release
```

### Edge
```bash
flutter run -d edge --release
```

### Firefox (if configured)
```bash
flutter run -d firefox --release
```

---

## 📦 Method 3: Deploy to Web Hosting

The `build/web` folder contains a **fully static website** that can be deployed to:

- **Netlify**: Drag & drop the `build/web` folder
- **Vercel**: Deploy via CLI or Git integration
- **GitHub Pages**: Push to `gh-pages` branch
- **Firebase Hosting**: `firebase deploy`
- **Any static hosting service**

### Example: GitHub Pages
```bash
# Build the app
flutter build web --release --base-href "/your-repo-name/"

# Push build/web to gh-pages branch
git subtree push --prefix build/web origin gh-pages
```

---

## 🔧 Alternative Web Servers

If Python is not available, use any of these:

### Node.js (http-server)
```bash
npm install -g http-server
cd build/web
http-server -p 8080
```

### PHP
```bash
cd build/web
php -S localhost:8080
```

### Live Server (VS Code Extension)
1. Install "Live Server" extension
2. Right-click `build/web/index.html`
3. Select "Open with Live Server"

---

## 📱 Mobile Browsers

TaskNest also works on mobile browsers:
- ✅ Safari (iOS)
- ✅ Chrome (Android/iOS)
- ✅ Firefox (Android/iOS)
- ✅ Edge (Android/iOS)
- ✅ Samsung Internet

---

## 🎨 Features

- **Responsive Design**: Automatically adapts to desktop and mobile
- **Material 3**: Modern, beautiful UI
- **Google Fonts (Inter)**: Clean, professional typography
- **Hover Effects**: Smooth color transitions and elevations
- **Auto-Renderer**: Automatically selects the best rendering engine for your browser

---

## 🐛 Troubleshooting

### App won't load
1. Clear your browser cache (Ctrl+Shift+Delete or Cmd+Shift+Delete)
2. Try a different browser
3. Check browser console (F12) for errors
4. Ensure you're accessing via `http://localhost:8080` not `file://`

### Port 8080 already in use
Change the port number:
```bash
python -m http.server 3000
```
Then access via `http://localhost:3000`

### CORS errors
Always use a web server (Methods 1-3 above). Never open `index.html` directly as a file.

---

## ✨ Current Server Status

If you ran the Python server, TaskNest should be accessible at:

**🌐 http://localhost:8080**

Open this URL in **any browser** to start using TaskNet!

---

## 📝 Browser Compatibility

| Browser | Version | Status |
|---------|---------|--------|
| Chrome | 90+ | ✅ Fully Supported |
| Edge | 90+ | ✅ Fully Supported |
| Firefox | 88+ | ✅ Fully Supported |
| Safari | 14+ | ✅ Fully Supported |
| Opera | 76+ | ✅ Fully Supported |
| Brave | Latest | ✅ Fully Supported |

---

**Built with Flutter Web - Universal Browser Support**
