resource "aws_codecommit_repository" "code-repo" {
    repository_name = var.repo-name
    description = "Creates a new codecommit repository with defined name"
}