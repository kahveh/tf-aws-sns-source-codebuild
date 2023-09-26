locals {
  notification_name     = try(var.notification_name, "project")
  sns_topic_arn         = var.sns_topic_arn
  codebuild_project_arn = var.codebuild_project_arn
  phase_detail          = var.enable_full_codebuild_phase_detail ? "FULL" : "BASIC"
  state_detail          = var.enable_full_codebuild_state_detail ? "FULL" : "BASIC"
}

## IAM
data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["codestar-notifications.amazonaws.com"]
    }

    resources = [local.sns_topic_arn]
  }
}

resource "aws_sns_topic_policy" "this" {
  arn    = local.sns_topic_arn
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_codestarnotifications_notification_rule" "codebuild_state" {
  count          = var.enable_codebuild_state_notifications ? 1 : 0
  detail_type    = local.state_detail
  event_type_ids = [
    "codebuild-project-build-state-failed",
    "codebuild-project-build-state-succeeded",
    "codebuild-project-build-state-in-progress",
    "codebuild-project-build-state-stopped"
  ]

  name     = "${local.notification_name}-codebuild-state-notification"
  resource = local.codebuild_project_arn

  target {
    address = local.sns_topic_arn
  }
}

resource "aws_codestarnotifications_notification_rule" "codebuild_phase" {
  count          = var.enable_codebuild_phase_notifications ? 1 : 0
  detail_type    = local.phase_detail
  event_type_ids = [
    "codebuild-project-build-phase-failure",
    "codebuild-project-build-phase-success"
  ]

  name     = "${local.notification_name}-codebuild-phase-notification"
  resource = local.codebuild_project_arn

  target {
    address = local.sns_topic_arn
  }
}