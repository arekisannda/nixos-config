{ config, ... }:

let terminal = config.setup.terminal.theme;
in {
  programs.gh-dash = {
    enable = true;
    settings = {
      prSections = [
        {
          title = "My Pull Requests";
          filters = "is:open author:@me";
        }
        {
          title = "Needs My Review";
          filters = "is:open review-requested:@me";
        }
        {
          title = "Involved";
          filters = "is:open involves:@me -author:@me";
        }
      ];

      issuesSections = [
        {
          title = "My Issues";
          filters = "is:open author:@me";
        }
        {
          title = "Assigned";
          filters = "is:open assignee:@me";
        }
        {
          title = "Involved";
          filters = "is:open involves:@me -author:@me";
        }
        {
          title = "Kubernetes";
          filters = "is: open repo:kubernetes/Kubernetes";
        }
      ];

      defaults = {
        preview = {
          open = true;
          width = 50;
        };

        prsLimit = 20;
        issuesLimit = 20;
        view = "prs";

        layout = {
          prs = {
            updatedAt.width = 7;
            repo.width = 15;
            author.width = 15;
            lines.width = 16;

            assignees = {
              width = 20;
              hidden = true;
            };

            base = {
              width = 15;
              hidden = true;
            };
          };

          issues = {
            updatedAt.width = 7;
            repo.width = 15;
            creator.width = 10;

            assignees = {
              width = 20;
              hidden = true;
            };
          };

          refetchIntervalMinutes = 30;
        };
      };

      keybindings = {
        issues = [ ];
        prs = [ ];
      };

      repoPaths = { };

      theme = {
        ui.table.showSeparator = true;
        colors = {
          text = {
            primary = "#${terminal.colors.foreground.normal}";
            secondary = "#${terminal.colors.normal.cyan}";
            inverted = "#${terminal.colors.bright.black}";
            faint = "#${terminal.colors.foreground.dim}";
            warning = "#${terminal.colors.normal.red}";
            success = "#${terminal.colors.normal.green}";
          };

          background = { selected = "#${terminal.colors.background.bright}"; };

          border = {
            primary = "#${terminal.colors.background.bright}";
            secondary = "#${terminal.colors.background.bright}";
            faint = "#${terminal.colors.background.dim}";
          };
        };
      };

      pager.diff = "";
    };
  };
}
