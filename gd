
{
  "manifest_version": 3,
  "name": "MCAT UI Fix",
  "version": "1.0.0",
  "description": "Skryje konkrétní prvek u MCAT po načtení stránky.",
  "content_scripts": [
    {
      "matches": ["http://ottm15c06pc02/*"],
      "js": ["content.js"],
      "run_at": "document_idle"
    }
  ]
}



(function () {
  function hideElement() {
    var btn = document.getElementById('btnOk');
    if (!btn) return false;

    var p = btn;
    while (p && (!p.className || p.className.indexOf('form-group') === -1)) {
      p = p.parentNode;
    }
    if (p) {
      p.style.display = 'none';
      return true;
    }
    return false;
  }

  // 1) Zkus hned
  if (hideElement()) return;

  // 2) Když to je SPA / načítá se pozdě: sleduj DOM
  var obs = new MutationObserver(function () {
    if (hideElement()) obs.disconnect();
  });

  obs.observe(document.documentElement, { childList: true, subtree: true });

  // 3) Pojistka: po 10s to vypni, ať to nežere výkon
  setTimeout(function () {
    try { obs.disconnect(); } catch (e) {}
  }, 10000);
})();
