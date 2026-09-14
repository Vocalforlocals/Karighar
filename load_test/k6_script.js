// load_test/k6_script.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: __ENV.DURATION || '1m', target: Number(__ENV.VUS) || 50 },
  ],
};

export default function () {
  const baseUrl = __ENV.BASE_URL || 'https://karighar.vercel.app';
  const res = http.get(baseUrl);
  check(res, {
    'status is 200': (r) => r.status === 200,
  });
  sleep(1);
}
