const EdgePersonal = {
  name: "Microsoft Edge",
  profile: "Profile 1", // fall back to "Default" if display names don't match
};

const EdgeWork = {
  name: "Microsoft Edge",
  profile: "Birdeye", // fall back to "Profile 2" if display names don't match
};

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
  defaultBrowser: EdgePersonal,

  handlers: [
    {
      match: (url) =>
        workHosts.some(
          (host) => url.host === host || url.host.endsWith(`.${host}`),
        ),
      browser: EdgeWork,
    },
  ],
};
