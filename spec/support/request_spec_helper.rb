module RequestSpecHelper
    # Parse JSON response to ruby hash which is easier to work with in tests.
    def json
      JSON.parse(response.body)
    end
  end