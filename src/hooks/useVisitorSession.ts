import { useEffect, useState } from 'react';

export function useVisitorSession() {
  const [visitorToken, setVisitorToken] = useState<string | null>(null);

  useEffect(() => {
    let token = localStorage.getItem('visitor_token');
    if (!token) {
      token = crypto.randomUUID();
      localStorage.setItem('visitor_token', token);
    }
    setVisitorToken(token);
  }, []);

  return visitorToken;
}
