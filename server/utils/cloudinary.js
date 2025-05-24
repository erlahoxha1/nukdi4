const cloudinary = require('cloudinary').v2;

cloudinary.config({
  cloud_name: 'dy7dijkbh',
  api_key: '985775871551299',
  api_secret: 'BigiC46t9HiA0edmOREeiHAKTt0',
});

async function uploadToCloudinary(buffer, folder) {
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      { folder },
      (err, result) => {
        if (err) reject(err);
        else resolve(result);
      }
    );
    stream.end(buffer);
  });
}

module.exports = { uploadToCloudinary };
