# UXPagerView
Built in swift for iOS

Checkout for detailed Project - [Deepakgoyal-iOS/UXPagerViewProject](https://github.com/Deepakgoyal-iOS/UXPagerViewProject)


https://github.com/user-attachments/assets/81a0da6d-d801-444a-b2d2-bd5032ab2c14




-- FEATURE

    -- Swipe between pages
    -- Can have many pages
    -- Show page on tab select
    -- Count badge
    -- Able to set limit to cache page. Default is 2
    -- Able to configure custom cell for tab
    -- Able to clear cache manually
    

-- OPTIMIZATION 

    If there are 1000s of pages this library will handle very smoothly as we cache limited number of pages.
    At any time there can be at most [cache limit + last accessed Page] number of pages in memory.
                  
    Explaination - 
                  
    By default cache limit value is 2 so maximum number of pages can be in memory is 4.
    How ?
    - 2 pages define we need to cache 1 left & 1 right page of current accessed page. (Note : Cache limit can be in even so if limit is 6 then if caches - 3 left & 3 right).
    - 1 page is the current page cached.
    - 1 page is last accessed page.
                  
                  

-- SUPPORT 

    -- iOS 11.0+
