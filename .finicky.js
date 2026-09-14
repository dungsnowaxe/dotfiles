const workBrowser = { name: "Google Chrome", profile: "Profile 2" }; // "Work"

const workHosts = [
  "slack.com",
  "app.slack.com",
  "atlassian.net", // Jira + Confluence cloud
  "jira.com",
  "confluence.com",
  "expo.dev",
  "firebase.google.com",
  "console.firebase.google.com",
  "play.google.com",
  "playconsole.google.com",
  "console.cloud.google.com",
];

module.exports = {
  // pin the profile, else Chrome opens links in its last-used profile
  defaultBrowser: { name: "Google Chrome", profile: "Default" },

  handlers: [
    {
      match: (url) =>
        workHosts.some(
          (host) => url.host === host || url.host.endsWith(`.${host}`),
        ),
      browser: workBrowser,
    },
  ],
};
