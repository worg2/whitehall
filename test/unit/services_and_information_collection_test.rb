require "test_helper"

class ServicesAndInformationCollectionTest < ActiveSupport::TestCase
  test ".build_collection_group_from creates an array of collections" do
    search_results = [{
      title: "Example subsector",
      examples: [ { title: "A document title", link: "/a-document-link" } ],
      document_count: 1,
      subsector_link: "sector/example-subsector"
    }]

    collection = ServicesAndInformationCollection.build_collection_group_from(search_results)

    assert_equal 1, collection.length
    assert_equal "Example subsector", collection[0].title
    assert_equal "sector/example-subsector", collection[0].subsector_link
    assert_equal 1, collection[0].document_count
    assert_equal 1, collection[0].examples.length
  end

  test "#title_for_example_at returns the title for the example specified by index" do
    collection = ServicesAndInformationCollection.new(
      title: "Example subsector",
      subsector_link: "/example-subsector",
      examples: [ { title: "Example document", link: "/example-document" } ],
      document_count: 1
    )

    assert_equal "Example document", collection.title_for_example_at(0)
  end

  test "#link_for_example_at returns the link for the example specified by index" do
    collection = ServicesAndInformationCollection.new(
      title: "Example subsector",
      subsector_link: "/example-subsector",
      examples: [ { title: "Example document", link: "/example-document" } ],
      document_count: 1
    )

    assert_equal "/example-document", collection.link_for_example_at(0)
  end
end
