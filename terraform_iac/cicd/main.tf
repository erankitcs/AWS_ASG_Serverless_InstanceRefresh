resource "aws_s3_bucket" "amibuild_codepipeline_bucket" {
  bucket = "amibuildartifactcodepipeline"
  acl    = "private"
}

resource "aws_codepipeline" "amibuild_codepipeline" {
  name     = "tf-test-pipeline"
  role_arn = aws_iam_role.amibuild_codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.amibuild_codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["amibuild_artifacts"]

      configuration = {
        Owner      = "erankitcs"
        Repo       = "AWS_ASG_Serverless_InstanceRefresh"
        Branch     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["amibuild_artifacts"]
      output_artifacts = ["amibuild_output"]
      version          = "1"

      configuration = {
        ProjectName = "AMIBUILD_WITHPACKER"
      }
    }
  }
}

data "aws_ssm_parameter" "github_token" {
  name = var.github_token_ssmps
}

resource "aws_codepipeline_webhook" "amibuild_cp_wh" {
  name            = "amibuild_cp_webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.amibuild_codepipeline.name

  authentication_configuration {
    secret_token = data.aws_ssm_parameter.github_token.value
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

# Wire the CodePipeline webhook into a GitHub repository.
resource "github_repository_webhook" "bar" {
  repository = var.repository
  name = "amibuild_webhook"
  configuration {
    url          = aws_codepipeline_webhook.amibuild_cp_wh.url
    content_type = "json"
    insecure_ssl = true
    secret       = data.aws_ssm_parameter.github_token.value
  }
  events = ["push"]
}