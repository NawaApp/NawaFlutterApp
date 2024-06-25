async function loadEnv() {
    const response = await fetch('.env');
    const text = await response.text();
    const env = text.split('\n')
      .filter(line => line.trim() !== '' && !line.startsWith('#'))
      .reduce((acc, line) => {
        const [key, value] = line.split('=');
        acc[key.trim()] = value.trim();
        return acc;
      }, {});
  
    return env;
  }
  
  window.loadEnv = loadEnv;
  