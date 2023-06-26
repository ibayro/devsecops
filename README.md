# devsecops

This branch contains a pre-commit script that installs gitleaks on a local machine, and initiates gitleaks scanning, displays the results, if the secrets have been detected, the script initiates protection.

1. Make the script executable:
   ```
   chmod +x pre-commit.sh
   ```

2. Move the script to the `.git/hooks` directory of your working Git repository:
   ```
   mv pre-commit.sh .git/hooks/pre-commit
   ```

3. `git config hooks.gitleaks-enable true` enables the hook to work automatically.
    ```
   git config hooks.gitleaks-enable true
   ```
   If not enabled, the hook will not work until manually triggered.

4. Optionally, you can configure Git to automatically enable the pre-commit hook by setting the `core.hooksPath` configuration:
   ```
   git config core.hooksPath .git/hooks
   ```

5. Whenever you make a commit in your repository, the pre-commit hook script will be executed, and it will run gitleaks to check for secrets. If any secrets are found, the commit will be rejected; otherwise, the commit will be allowed.
