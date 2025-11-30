#!/usr/bin/env bash

aws_profile_usage() {
  cat <<EOF
Usage: aws-profile [OPTIONS] PROFILE [-r REGION]

Manages AWS profiles and SSO authentication (via 'assume' from granted).

OPTIONS:
  -h, --help      Show this help
  -c              Login via SSO to console and set profile active
  -r REGION       Set AWS region (optional)
  -u              Unset active profile
  -x              Logout of SSO and unset profile

PARAMETERS:
  PROFILE         Name of AWS profile

EXAMPLES:
  aws-profile my-profile -r us-west-2
  aws-profile my-profile
  aws-profile -c my-profile -r us-west-2
  aws-profile -u
  aws-profile -x
EOF
}

aws_profile_unset() {
  log_info "Unsetting AWS profile/environment"
  unset ENV AWS_PROFILE AWS_ACCOUNT AWS_REGION AWS_DEFAULT_REGION 2>/dev/null || true

  if command -v assume >/dev/null 2>&1; then
    assume --unset 2>/dev/null || log_warn "Could not unset assume session"
  fi
}

aws_profile_logout_sso() {
  if command -v granted >/dev/null 2>&1; then
    log_info "Clearing Granted SSO tokens"
    granted sso-tokens clear --all 2>/dev/null || log_warn "Could not clear SSO tokens"
  else
    log_warn "'granted' not installed; skipping SSO logout"
  fi
}

aws_profile_switch() {
  # Pass everything directly to 'assume'
  local assume_cmd
  assume_cmd=$(command -v assume 2>/dev/null)
  
  if [[ -z "$assume_cmd" ]]; then
    log_error "'assume' command not found. Please install 'granted'."
    return 1
  fi

  log_info "Assuming profile via granted: assume $*"
  # Source assume since it needs to modify the current shell environment
  source "$assume_cmd" "$@"
  local source_result=$?
  
  if [[ $source_result -eq 0 ]]; then
    # granted sets AWS_PROFILE / AWS_REGION etc
    export ENV="${AWS_PROFILE:-}"

    # Don't fail if whoami fails - it's not critical
    aws_whoami_main >/dev/null 2>&1 || true
    log_debug "Profile switch completed successfully"
    return 0
  else
    log_error "Failed to assume AWS profile (exit code: $source_result)"
    return 1
  fi
}

aws_profile_main() {
  if [[ $# -eq 0 ]]; then
    aws_profile_usage
    return 1
  fi

  case "$1" in
  -h | --help)
    aws_profile_usage
    ;;
  -u)
    aws_profile_unset
    ;;
  -x)
    aws_profile_unset
    aws_profile_logout_sso
    ;;
  -c)
    shift
    # console login via assume (e.g., assume -c profile)
    aws_profile_switch "-c" "$@"
    ;;
  *)
    # generic: aws-profile <profile> [region...]
    aws_profile_switch "$@"
    ;;
  esac
}

aws_whoami_main() {
  if [[ -z "${AWS_PROFILE:-}" ]]; then
    echo "No AWS profile is set"
    return 1
  fi

  log_info "Getting AWS identity for profile '$AWS_PROFILE'"

  local account_alias
  account_alias=$(aws iam list-account-aliases \
    --query "AccountAliases[0]" --output text 2>/dev/null) || {
    log_error "Could not retrieve account alias"
    return 1
  }

  local user_id account arn
  if read -r user_id account arn <<<"$(aws sts get-caller-identity \
    --query "[UserId,Account,Arn]" --output text 2>/dev/null)"; then
    if [[ -n "$account_alias" && "$account_alias" != "None" ]]; then
      echo "AWS Account Alias: $account_alias"
    fi
    echo "User:    $user_id"
    echo "Account: $account"
    echo "Arn:     $arn"
    export AWS_ACCOUNT="$account"
  else
    log_error "Could not retrieve caller identity"
    return 1
  fi
}

aws_list_profiles() {
  if [[ -f "$HOME/.aws/config" ]]; then
    grep '^\[profile ' "$HOME/.aws/config" |
      awk '{ print substr($2,1,length($2)-1) }'
  else
    log_warn "No ~/.aws/config found"
  fi
}
