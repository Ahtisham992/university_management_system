import axios from 'axios';
import { getBackendUrl } from '../config';

const API_BASE_URL = getBackendUrl();

const api = axios.create({
  baseURL: API_BASE_URL,
  withCredentials: true,
});

export default api;