// Light/dark theme toggle. A remembered choice is applied by an inline script
// in templates/partials/head.html before first paint; this file reveals the
// toggle button and handles clicks.
(() => {
  const root = document.documentElement;
  const button = document.querySelector(".theme-toggle");
  const prefersDark = window.matchMedia("(prefers-color-scheme: dark)");

  if (!button) return;

  const currentTheme = () => root.dataset.theme ?? (prefersDark.matches ? "dark" : "light");

  button.hidden = false;
  button.addEventListener("click", () => {
    const next = currentTheme() === "dark" ? "light" : "dark";
    root.dataset.theme = next;
    try {
      localStorage.setItem("theme", next);
    } catch {
      // Storage unavailable (e.g. private mode): the choice lasts for this page only.
    }
  });
})();
