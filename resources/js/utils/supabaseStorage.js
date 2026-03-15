import { supabase } from '../config/supabase';

/**
 * Upload file to Supabase Storage
 * @param {string} bucket - Bucket name (e.g., 'avatars', 'documents')
 * @param {File} file - File object to upload
 * @param {string} path - File path in bucket (e.g., 'user-123/avatar.jpg')
 * @returns {Promise<{url: string, path: string}>}
 */
export const uploadFile = async (bucket, file, path) => {
  try {
    const { data, error } = await supabase.storage
      .from(bucket)
      .upload(path, file, {
        cacheControl: '3600',
        upsert: false,
      });

    if (error) throw error;

    // Get public URL
    const { data: { publicUrl } } = supabase.storage
      .from(bucket)
      .getPublicUrl(data.path);

    return { url: publicUrl, path: data.path };
  } catch (err) {
    console.error('File upload error:', err);
    throw err;
  }
};

/**
 * Upload file and replace existing (upsert)
 * @param {string} bucket - Bucket name
 * @param {File} file - File object to upload
 * @param {string} path - File path in bucket
 * @returns {Promise<{url: string, path: string}>}
 */
export const uploadFileUpsert = async (bucket, file, path) => {
  try {
    const { data, error } = await supabase.storage
      .from(bucket)
      .upload(path, file, {
        cacheControl: '3600',
        upsert: true,
      });

    if (error) throw error;

    // Get public URL
    const { data: { publicUrl } } = supabase.storage
      .from(bucket)
      .getPublicUrl(data.path);

    return { url: publicUrl, path: data.path };
  } catch (err) {
    console.error('File upload error:', err);
    throw err;
  }
};

/**
 * Delete file from Supabase Storage
 * @param {string} bucket - Bucket name
 * @param {string} path - File path in bucket
 */
export const deleteFile = async (bucket, path) => {
  try {
    const { error } = await supabase.storage
      .from(bucket)
      .remove([path]);

    if (error) throw error;
  } catch (err) {
    console.error('File deletion error:', err);
    throw err;
  }
};

/**
 * Get public URL for a file
 * @param {string} bucket - Bucket name
 * @param {string} path - File path in bucket
 * @returns {string} Public URL
 */
export const getPublicUrl = (bucket, path) => {
  const { data } = supabase.storage.from(bucket).getPublicUrl(path);
  return data.publicUrl;
};

/**
 * List files in a bucket
 * @param {string} bucket - Bucket name
 * @param {string} folderPath - Folder path (optional)
 */
export const listFiles = async (bucket, folderPath = '') => {
  try {
    const { data, error } = await supabase.storage
      .from(bucket)
      .list(folderPath, {
        limit: 100,
        offset: 0,
        sortBy: { column: 'name', order: 'asc' },
      });

    if (error) throw error;
    return data;
  } catch (err) {
    console.error('List files error:', err);
    throw err;
  }
};
