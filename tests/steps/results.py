from behave import *
from contextlib import contextmanager
from subprocess import check_output, check_call
import os
from glob import glob


@contextmanager
def cd(newdir):
    prevdir = os.getcwd()
    os.chdir(os.path.expanduser(newdir))
    try:
        yield
    finally:
        os.chdir(prevdir)


@then("it succeeds")
def step_impl(context):
    assert context.result == 0


@then("it fails")
def step_impl(context):
    assert context.result != 0


@then('generates a message "{text}"')
def step_impl(context, text):
    assert context.error.find(text) != -1


@then("gitignore lists xml files")
def step_impl(context):
    with cd(context.working_dir):
        md_files = glob("draft-*.md")
        for md in md_files:
            context.execute_steps(f'then gitignore lists "{md.replace(".md", ".xml")}"')


@then("gitignore negation rules come last")
def step_impl(context):
    with cd(context.working_dir):
        with open(".gitignore", mode="r") as f:
            neg = False
            for line in f.read().splitlines():
                if line[0] == "!":
                    neg = True
                else:
                    assert neg == False


@then('gitignore lists "{ignore}"')
def step_impl(context, ignore):
    with cd(context.working_dir):
        c = check_output(["grep", "-c", ignore, ".gitignore"]).decode("utf-8")
        assert int(c) == 1


@then("generates documents")
def step_impl(context):
    with cd(context.working_dir):
        md_files = glob("draft-*.md")
        for md in md_files:
            txt_file = md.replace(".md", ".txt")
            html_file = md.replace(".md", ".html")
            assert os.path.isfile(txt_file)
            assert os.path.isfile(html_file)


@then("generates upload files")
def step_impl(context):
    with cd(context.working_dir):
        for md in glob("draft-*.md"):
            if "-00.md" not in md:
                upload_file = "versioned/." + md.replace(".md", "-00.upload")
                assert os.path.isfile(upload_file)


@then("documents are added to gh-pages")
def step_impl(context):
    with cd(context.working_dir):
        md_files = glob("draft-*.md")
        ghpages_files = check_output(
            ["git", "ls-tree", "gh-pages", "--name-only", "-r"]
        ).decode("utf-8")
        for md in md_files:
            txt_file = md.replace(".md", ".txt")
            html_file = md.replace(".md", ".html")
            assert txt_file in ghpages_files
            assert html_file in ghpages_files


@then('a file is created called "{filename}" which contains "{text}"')
def step_impl(context, filename, text):
    context.execute_steps(
        f'then a branch is created called "main" containing "{filename}" which contains "{text}"'
    )


@then('a file is created called "{filename}"')
def step_impl(context, filename):
    context.execute_steps(
        f'then a branch is created called "main" containing "{filename}"'
    )


@then(
    'a branch is created called "{branch}" containing "{filename}" which contains "{text}"'
)
def step_impl(context, branch, filename, text):
    context.execute_steps(
        f'then a branch is created called "{branch}" containing "{filename}"'
    )
    with cd(context.working_dir):
        content = check_output(["git", "show", f"{branch}:{filename}"]).decode("utf-8")
        assert text in content


@then('a branch is created called "{branch}" containing "{filename}"')
def step_impl(context, branch, filename):
    with cd(context.working_dir):
        files = check_output(["git", "ls-tree", branch, "--name-only", "-r"]).decode(
            "utf-8"
        )
        assert filename in files


@then("a precommit hook is installed")
def step_impl(context):
    with cd(context.working_dir):
        assert len(glob(".git/hooks/pre-commit")) == 1
