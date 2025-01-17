export default function sendTimezoneToServer() {
  const timezone = -(new Date().getTimezoneOffset() / 60);
  const csrfTokenMeta = document.querySelector("meta[name='csrf-token']") as HTMLMetaElement;
  const csrfToken = csrfTokenMeta ? csrfTokenMeta.getAttribute("content") : '';

  if (typeof window.localStorage !== 'undefined') {
      try {
          // if we sent the timezone already or the timezone changed since last time we sent
          if (!localStorage.getItem("timezone") || localStorage.getItem("timezone") !== timezone.toString()) {
              fetch('/session/set-timezone', {
                  method: 'POST',
                  headers: {
                      'Content-Type': 'application/json',
                      'x-csrf-token': csrfToken || ''
                  },
                  body: JSON.stringify({ timezone: timezone })
              })
              .then(response => {
                  if (response.ok) {
                      localStorage.setItem('timezone', timezone.toString());
                  }
              })
              .catch(error => {
                  console.error('Error:', error);
              });
          }
      } catch (e) {
          console.error('Error:', e);
      }
  }
}
