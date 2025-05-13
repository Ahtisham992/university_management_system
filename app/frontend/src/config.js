export const getBackendUrl = () => {
  // Use environment variable if set
  if (process.env.REACT_APP_BASE_URL) {
    return process.env.REACT_APP_BASE_URL;
  }

  // Fallback to default local development URL
  return 'http://localhost:3000';
};