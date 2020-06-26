# expenses-tracker
### blck-shp

---

### API

- [x] Authentication
    - [x] Registration
    - [x] Login
- [x] Categories
    - [x] Fetching Categories
- [x] Records
    - [x] Authentication
    - [x] Create
    - [x] Fetch all
    - [x] Update
    - [x] Delete
    - [x] Overview
    - [x] Seed

---

### Pages

- [x] Onboarding
- [x] Registration
- [x] Login
- [x] Dashboard
    - [x] Empty view
    - [x] Normal view
- [x] Logout
- [x] Create Record
- [x] Modify an existing record
- [x] All Records Page
    - [x] Pagination
    - [x] Search

---

### Additional Info

- Added validators when an intended task isn't met or for validating a certain task
- Deletion of a record by swiping right or long pressing it.

---

### Issues

- [x] Add Record needs to have a back button, not a menu button.
- [x] The Date, Time and Category fields should be autofilled. The default date and time should be set to today and the category to the first in the list.
- [x] There's an error when scrolling through search entries. There are more pages here so I should be able to scroll through the pages.
- [x] The title of this page should be Categories, and if a category has been previously selected in the Add Record page, the category here should be highlighted. As with item #1, the menu button should be replaced with a back button. Also if I navigate back to the Home page from this page, it shows me an "Error" label and I cannot go back to the original Home page overview.
- [x] The delete icon in the Edit Record page should delete the record, not clear the changes.
- [x] When editing a record, the user cannot change the record type from Income to Expense and vice versa.
- [x] As much as possible this tiny listview should accommodate the entire height of the list, so it should show 5 items

---

### Issue # 2 [Updates]

##### UI
- [x] The chart overflows the container sometimes
- [x] The amount should be green if the record_type is income, red otherwise. Also, try to format the date in a more human-readable form, ie. "June 23, 2020". Please also use the category icons that are returned in the GET /api/v1/categories response. 
- [x] Time field formatting on the minutes portion needs to be zero-padded.

##### Functionality
- [x] Navigation // Dashboard should be the root page so when you reach the end of the stack, pressing back shouldn't take you to the Login page. - This is not done yet.
- [x]  Editing record from Dashboard // There are some issues on the implementation initialization.
- [x] More edit record shenanigans // There are still issues on editing a record,

---

### Additional info as of June 26, 2020.

So far, all of the issues mentioned above were all fixed and have been tested along the way but the code needs to be refactored. The UI of this mini project has also been updated or modified especially in regards to the currency and the list tiles that are being displayed.
