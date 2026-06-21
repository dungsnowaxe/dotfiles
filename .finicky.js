const BravePersonal = {
  name: "Brave Browser",
  profile: "Default",
};

const BraveWork = {
  name: "Brave Browser",
  profile: "Birdeye", // change to "Profile 1/2/3" if this doesn't work
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
  defaultBrowser: BravePersonal,

  handlers: [
    {
      match: (url) => {
        console.log(`Checking URL: ${JSON.stringify(url)}`);
        return workHosts.some(
          (host) => url.host === host || url.host.endsWith(`.${host}`),
        );
      },
      browser: BraveWork,
    },
  ],
};
