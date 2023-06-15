# frozen_string_literal: true

require "test_helper"

class TestGoogledrive < Minitest::Test
  include Examples::Googledrive
  def setup
    db_config = YAML::load(File.read('db/database.yml'))["postgres"]

    ActiveRecord::Tasks::DatabaseTasks.database_configuration = db_config
    ActiveRecord::Base.establish_connection db_config

    ActiveRecord::Tasks::DatabaseTasks.migrate
  end
  def test_a_user_can_perform_all_actions_on_a_document_when_they_own_the_document
    org = Organization.create(name: "Acme")
    user = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: user)

    owner = org.users.create(name: "Alice")
    document = folder.documents.create(name: "plan.doc", owner: owner)

    assert document.relations(:viewer).include? user
    assert document.relations(:commenter).include? user
    assert document.relations(:editor).include? user
  end

  def test_a_user_can_view_a_document_when_they_have_the_viewer_role_for_the_document
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    document = folder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    DocumentUser.create(user: user, document: document, role: :viewer)

    assert document.relations(:viewer).include? user
  end

  def test_a_user_can_edit_a_document_when_they_have_the_editor_role_for_the_document
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    document = folder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    DocumentUser.create(user: user, document: document, role: :editor)

    assert document.relations(:editor).include? user
  end

  def test_a_user_can_view_a_document_when_they_have_the_commenter_role_for_the_document
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    document = folder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    DocumentUser.create(user: user, document: document, role: :commenter)

    assert document.relations(:viewer).include? user
  end

  def test_a_user_can_view_a_document_when_they_have_the_editor_role_for_the_document
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    document = folder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    DocumentUser.create(user: user, document: document, role: :editor)

    assert document.relations(:viewer).include? user
  end

  def test_a_user_can_comment_on_a_document_when_they_have_the_commenter_role_for_the_document
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    document = folder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    DocumentUser.create(user: user, document: document, role: :commenter)

    assert document.relations(:commenter).include? user
  end

  def test_a_user_can_comment_on_a_document_when_they_have_the_editor_role_for_the_document
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    document = folder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    DocumentUser.create(user: user, document: document, role: :editor)

    assert document.relations(:commenter).include? user
  end

  def test_a_user_can_edit_a_document_when_the_user_organization_has_the_editor_role_for_the_document
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    document = folder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    DocumentOrganization.create(organization: org, document: document, role: :editor)

    assert document.relations(:editor).include? user
    assert document.relations(:commenter).include? user
    assert document.relations(:viewer).include? user
  end

  def test_a_user_can_comment_on_a_document_when_the_user_organization_has_the_commenter_role_for_the_document
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    document = folder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    DocumentOrganization.create(organization: org, document: document, role: :commenter)

    assert document.relations(:commenter).include? user
    assert document.relations(:viewer).include? user
  end

  def test_a_user_can_view_a_document_when_the_user_organization_has_the_viewer_role_for_the_document
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    document = folder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    DocumentOrganization.create(organization: org, document: document, role: :viewer)

    assert document.relations(:viewer).include? user
  end

  def test_a_user_can_edit_a_document_when_they_have_the_editor_role_on_the_document_folder
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    document = folder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    FolderUser.create(folder: folder, user: user, role: :editor)

    assert document.relations(:editor).include? user
    assert document.relations(:commenter).include? user
    assert document.relations(:viewer).include? user
  end

  def test_a_user_can_comment_on_a_document_when_they_have_the_commenter_role_on_the_document_folder
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    document = folder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    FolderUser.create(folder: folder, user: user, role: :commenter)

    assert document.relations(:commenter).include? user
    assert document.relations(:viewer).include? user
  end

  def test_a_user_can_view_a_document_when_they_have_the_viewer_role_on_the_document_folder
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    document = folder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    FolderUser.create(folder: folder, user: user, role: :viewer)

    assert document.relations(:viewer).include? user
  end

  def test_a_user_can_perform_all_actions_on_a_document_when_they_are_the_owner_of_the_document_folder
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)

    user = org.users.create(name: "Alice")
    document = folder.documents.create(name: "plan.doc", owner: user)

    assert document.relations(:editor).include? owner
    assert document.relations(:commenter).include? owner
    assert document.relations(:viewer).include? owner
  end

  def test_a_user_can_perform_all_actions_on_a_document_when_they_are_the_owner_of_the_document_folder_parent
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)

    user = org.users.create(name: "Alice")
    subfolder = org.folders.create(name: "Drafts", user: user, parent: folder)

    document = subfolder.documents.create(name: "plan.doc", owner: user)

    assert document.relations(:editor).include? owner
    assert document.relations(:commenter).include? owner
    assert document.relations(:viewer).include? owner
  end

  def test_a_user_can_edit_a_document_when_they_are_an_editor_of_the_document_folder_parent
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    subfolder = org.folders.create(name: "Drafts", user: owner, parent: folder)
    document = subfolder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    FolderUser.create(folder: folder, user: user, role: :editor)

    assert document.relations(:editor).include? user
    assert document.relations(:commenter).include? user
    assert document.relations(:viewer).include? user
  end

  def test_a_user_can_edit_a_document_when_they_are_an_editor_of_the_document_folder_parent
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    subfolder = org.folders.create(name: "Drafts", user: owner, parent: folder)
    document = subfolder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    FolderUser.create(folder: folder, user: user, role: :commenter)

    assert document.relations(:commenter).include? user
    assert document.relations(:viewer).include? user
  end

  def test_a_user_can_view_a_document_when_they_are_an_editor_of_the_document_folder_parent
    org = Organization.create(name: "Acme")
    owner = org.users.create(name: "Bob")
    folder = org.folders.create(name: "Documents", user: owner)
    subfolder = org.folders.create(name: "Drafts", user: owner, parent: folder)
    document = subfolder.documents.create(name: "plan.doc", owner: owner)

    user = org.users.create(name: "Alice")

    FolderUser.create(folder: folder, user: user, role: :viewer)

    assert document.relations(:viewer).include? user
  end
end
