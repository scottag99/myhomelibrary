import { action, computed, observable } from 'mobx';

class AppState {
  @observable
  searchTerm = "Books...";

  @observable
  wishlist = [];

  @observable
  books = [];

  @observable
  cart = [];

  wishlistList = '/';

  constructor() {
    //This values are defined on common/_wishlist.html.erb
    this.wishlist = current_wishlist;
    this.books = all_active_books;
    this.wishlistList = back_url;
    this.reader = reader;
    this.grl = grl;
    this.bookLimit = book_limit;
    // convert letter value to int for comparison
    this.readerMin = this.grl.charCodeAt(0) - 1;
    this.readerMax = this.grl.charCodeAt(0) + 2;
  }

  @observable
  readingLevels = {
    'PreK-K': true,
    'G1-G2': true,
    'PreK-G2': true,
    'G3-G5': true
  };

  @observable
  grlFilter = '';

  @observable
  draFilter = '';

  @observable
  bilingualOnly = false;

  searchTerm = "";

  @computed
  get searchResults() {
    const term = this.searchTerm.toLowerCase();

    return this.books
      .filter(book => book.name.toLowerCase().indexOf(term) >= 0 || book.author.toLowerCase().indexOf(term) >= 0 || book.description.toLowerCase().indexOf(term) >= 0)
      .filter(book => this.filterByLevel(book))
      .filter(book => !this.wishlist.find((wish) => wish.catalog_entry_id === book.catalog_entry_id));
  }

  @action
  addToWishList(book) {
    if(this.wishlist.find((b) => b.catalog_entry_id === book.catalog_entry_id)) {
      return;
    }
    appState.wishlist = appState.wishlist.concat(book);

    $.ajax({
      url: api_add_url,
      dataType: 'json',
      method: 'POST',
      data: {wishlist_entry: {catalog_entry_id: book.catalog_entry_id}}
    }).done(function(data) {
      book.id = data.id;
    }).fail(function(data, status, error) {
      $(".modal-title").html('Error Adding Book');
      $(".modal-body").html("Book limit most likely reached. Remove a book from your list in order to add this one.");
      $('#globalModalError').modal();
      appState.wishlist = appState.wishlist.filter(b => b.catalog_entry_id !== book.catalog_entry_id);
    });
  }

  @action
  removeFromWishList(book) {
    $.ajax({
      url: api_delete_url.replace(':id', book.id),
      dataType: 'json',
      method: 'DELETE'
    }).done(function(data) {
      book.id = null;
      appState.wishlist = appState.wishlist.filter(b => b.catalog_entry_id !== book.catalog_entry_id);
    });
  }

  goBack() {
    var diff = appState.bookLimit - appState.wishlist.length
    if(diff > 0) {
      $(".modal-title").html('Add more books!');
      $(".modal-body").html(`You can still add books! Please add ${diff} book(s) to your wishlist.`);
      $('#globalModalError').modal();
    } else {
      document.location.href=appState.wishlistList;
    }
  }

  handleGradeLevel(event) {
    appState.readingLevels[event.target.value] = event.target.checked;
  }

  handleGrlFilter(event) {
    appState.draFilter = '';
    appState.grlFilter = event.target.value;
  }

  handleDraFilter(event) {
    appState.grlFilter = '';
    appState.draFilter = event.target.value;
  }

  handleBilingualFilter(event) {
    appState.bilingualOnly = event.target.id;
  }

  filterByLevel(book) {
    if (appState.bilingualOnly == 'bilingual' && !book.is_bilingual) {
      return false;
    }

    if (appState.bilingualOnly == 'english' && book.is_bilingual) {
      return false;
    }

    var draPresent = !(book.dra === undefined || book.dra.length < 1);
    var draMatch = false;
    if (draPresent) {
      var minMax = book.dra.split("-").map(function(v){ return parseInt(v)});
      var min = isNaN(minMax[0]) ? 0 : minMax[0];
      var max = isNaN(minMax[minMax.length-1]) ? 80 : minMax[minMax.length-1];
      draMatch = (min <= appState.draFilter && appState.draFilter <= max);
    }

    var grlMatch = appState.grlFilter != '' && book.grl == appState.grlFilter;

    //When any match is made, we always return true
    if (appState.readingLevels[book.level] || grlMatch || draMatch) {
      return true;
    }
    //If no levels exist on the book, return true
    //this keeps us from hiding books that can never be filterd
    var grlPresent = !(book.grl === undefined || book.grl.length < 1)
    var lvlPresent = !(book.level === undefined || book.level.length < 1)
    if (!draPresent && !grlPresent && !lvlPresent) {
      return true;
    }

    //If the GRL or DRA filters are not on, and the book has no grade level, return true
    if (!lvlPresent && appState.grlFilter == '' && appState.draFilter == '') {
      return true;
    }
    //Every other case should be false b/c there is a level value present but no filter matched
    return false;
  }
}

const appState = new AppState();

export default appState;
export { AppState };
