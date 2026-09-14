import http from 'k6/http';
import { check } from 'k6';

export const options = {
  vus: 10,
  duration: '30s',
};

export default function () {
  const response = http.get('http://localhost:3000');

  check(response, {
    'status is 200': (r) => r.status === 200,
  });
}