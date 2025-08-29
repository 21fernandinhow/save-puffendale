require "application_system_test_case"

class TaskListsTest < ApplicationSystemTestCase
  setup do
    @task_list = task_lists(:one)
  end

  test "visiting the index" do
    visit task_lists_url
    assert_selector "h1", text: "Task lists"
  end

  test "should create task list" do
    visit task_lists_url
    click_on "New task list"

    fill_in "Name", with: @task_list.name
    fill_in "User", with: @task_list.user_id
    click_on "Create Task list"

    assert_text "Task list was successfully created"
    click_on "Back"
  end

  test "should update Task list" do
    visit task_list_url(@task_list)
    click_on "Edit this task list", match: :first

    fill_in "Name", with: @task_list.name
    fill_in "User", with: @task_list.user_id
    click_on "Update Task list"

    assert_text "Task list was successfully updated"
    click_on "Back"
  end

  test "should destroy Task list" do
    visit task_list_url(@task_list)
    click_on "Destroy this task list", match: :first

    assert_text "Task list was successfully destroyed"
  end
end
