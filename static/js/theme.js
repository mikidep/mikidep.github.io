(() => {
  const storageKey = "theme";
  const root = document.documentElement;
  const button = document.querySelector("[data-theme-toggle]");
  const icon = document.querySelector("[data-theme-icon]");
  const media = window.matchMedia("(prefers-color-scheme: dark)");

  const activeTheme = () => root.dataset.theme || (media.matches ? "dark" : "light");

  const updateControl = () => {
    const theme = activeTheme();
    button.setAttribute("aria-pressed", String(theme === "dark"));
    button.setAttribute("aria-label", `Switch to ${theme === "dark" ? "light" : "dark"} mode`);
    icon.textContent = theme === "dark" ? "☀" : "◐";
  };

  button.addEventListener("click", () => {
    const nextTheme = activeTheme() === "dark" ? "light" : "dark";
    root.dataset.theme = nextTheme;
    try { localStorage.setItem(storageKey, nextTheme); } catch (_) {}
    updateControl();
  });

  media.addEventListener("change", () => {
    if (!root.dataset.theme) updateControl();
  });

  updateControl();
})();
