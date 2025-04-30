class OpenLibraryService
    include HTTParty

    def self.fetch_book_from_api(book_id)
        # /works/key/editions.json?limit=1
        book_url = "https://openlibrary.org/#{book_id}/editions.json?limit=1"
        response_book = HTTParty.get(book_url)
      
        if response_book.success? && response_book['entries'].any?
            edition_key = response_book['entries'].first['key']
            
            #/books/key.json
            single_book_url = "https://openlibrary.org#{edition_key}.json"
            response = HTTParty.get(single_book_url)

            # /works/key.json
            book_url_full = "https://openlibrary.org/#{book_id}.json"
            response_book_full = HTTParty.get(book_url_full)
            
            pages = response_book['entries'].first['number_of_pages'] || response['pagination']
            covers = response_book_full['covers'] || response_book['entries'].first['covers']
            isbn = response_book['entries'].first['isbn_13'] || response['isbn_13'] || response['isbn_10']
            title = response_book['entries'].first['full_title']  || response_book['entries'].first['title'] || response['title']        
      
            if response.success? && response_book_full.success?
                {
                title: title,
                subjects: response_book_full['subjects'],
                key: book_id,
                isbn: isbn,
                covers: covers,
                pages: pages
                }
            else
                nil
            end
        else
            nil
        end
    end
end