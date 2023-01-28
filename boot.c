#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

// types
struct object;
struct list;
typedef struct object object;
typedef struct list list;
typedef struct env env;

// memory allocation
[[gnu::always_inline]] static inline void *alloc(uint_fast8_t);

// read
[[gnu::nonnull(1)]] static object *read(char **);
[[gnu::always_inline]] [[gnu::nonnull(1)]] static inline object *read_atm(char **);
[[gnu::always_inline]] [[gnu::nonnull(1)]] static inline object *read_lst(char **);

// eval
[[gnu::nonnull(1, 2)]] static object *eval(object *, env *);
[[gnu::always_inline]] [[gnu::nonnull(1, 2)]] static inline object *eval_atm(char *, env *);
[[gnu::always_inline]] [[gnu::nonnull(1, 2)]] static inline object *eval_lst(list *, env *);

// misc
[[gnu::noinline]] void main(void);
[[gnu::always_inline]] [[gnu::nonnull(1, 2)]] static inline bool strequ(char *, char *);
[[gnu::always_inline]] [[gnu::nonnull(1, 2)]] static inline bool memequ(char *, char *, uint_fast8_t);
[[gnu::always_inline]] [[gnu::nonnull(1)]] static inline uint_fast8_t strlen(char *);
[[gnu::always_inline]] [[gnu::nonnull(1, 2)]] static inline void memcpy(void *, void *, uint_fast8_t);

struct object {
  union {
    char *atm;
    list *lst;
    void *bypass;
  } data;
  #pragma GCC diagnostic push
  #pragma GCC diagnostic ignored "-Wfixed-enum-extension"
  enum : uint_fast8_t { OBJATM, OBJLST } type;
  #pragma GCC diagnostic pop
};

// members are placed in this order to save 1 byte
struct list {
  list *cdr;
  object *car;
};

struct env {
  env *cdr;
  char *key;
  object *val;
};

static env nil = {
  .cdr = NULL,
  .key = "",
  .val = NULL
};

static char *memptr = (char *) 0x0500; // address where heap starts
static char *ptr = (char *) 0x7E00; // address where LISP code starts

void main(void) {
  eval(read(&ptr), &nil);
}

object *read(char **ptr) {
  for (;;)
    switch (**ptr) {
      case ';':
        do {
          (*ptr)++;
        } while (**ptr != '\n');
        (*ptr)++;
        break;
      case ' ':
      case '\n':
        (*ptr)++;
        break;
      case ')':
        (*ptr)++;
        return NULL;
      case '\0':
        return NULL;
      case '(':
        return read_lst(ptr);
      default:
        return read_atm(ptr);
    }
}

object *read_atm(char **ptr) {
  char *bgnptr = *ptr;

  // find the end of the atom
  do
    (*ptr)++;
  while (**ptr == '\0'
      || **ptr == ' '
      || **ptr == '\n'
      || **ptr == '('
      || **ptr == ')'
      || **ptr == ';');
  
  // copy its name to the heap
  int len = *ptr - bgnptr;
  
  char *name = alloc(len + 1);
  memcpy(name, bgnptr, len);
  name[len] = '\0';

  // return an atom object with that name
  object *res = alloc(sizeof(object));
  res->type = OBJATM;
  res->data.atm = name;
  
  return res;
}

object *read_lst(char **ptr) {
  list *lst = alloc(sizeof(list));
  list *endlst = lst;

  // append elements to a list until NULL is reached
  object *next = read(ptr);
  lst->car = next;
  for (;;) {
    next = read(ptr);
    if (next == NULL) break;
    endlst->cdr = alloc(sizeof(list));
    endlst = endlst->cdr;
    endlst->car = next;
  }
  endlst->cdr = NULL;

  // return a list object containing those element
  object *res = alloc(sizeof(object));
  res->type = OBJLST;
  res->data.lst = lst;
  return res;
}

void *alloc(uint_fast8_t size) {
  /*
  void *res;
  res = memptr;
  memptr += size;
  return res;
  */
  
  // saves 36 bytes
  void *res;
  __asm__("mov %0, %1 \n add %2, %0" : "+m" (memptr), "=r" (res) : "r" (size));
  return res;
}

void memcpy(void *dst, void *src, uint_fast8_t count) {
  /*
  do {
    *dst++ = *src++;
    count--;
  } while (count > 0);
  */
  
  // saves 35 bytes
  __asm__ volatile("rep movsb\n" :: "D" (dst), "S" (src), "c" (count));
}

object *eval(object *obj, env *e) {
  if (obj->type == OBJATM) {
    return eval_atm(obj->data.atm, e);
  } else /* if (obj->type == OBJLST */ {
    return eval_lst(obj->data.lst, e);
  }
}

object *eval_atm(char *name, env *e) {
  env *ptr = e;
  while (strequ(name, ptr->key)) {
    ptr = ptr->cdr;
    if (ptr == NULL)
      return NULL;
  }
  return eval(ptr->val, e);
}

object *eval_lst(list *lst, env *e) {
  object *car = eval(lst->car, e);
  list *cdr = NULL;
  list *cdrptr = cdr;
  list *ptr = lst->cdr;
  if (ptr != NULL) {
    cdr = alloc(sizeof(list));
    cdrptr = cdr;
    for (;;) {
      cdrptr->car = eval(ptr->car, e);
      if (ptr->cdr != NULL) {
        cdrptr->cdr = alloc(sizeof(list));
        cdrptr = cdrptr->cdr;
        ptr = ptr->cdr;
      } else {
        break;
      }
    }
  }
  cdrptr->cdr = NULL;
  // inline asm is used here to prevent clang
  // from eliminating the whole function
  __asm__ volatile ("" : "=rmi" (car), "=rmi" (cdr));
  /*
  if (car->type == OBJATM && strequ(car->data.atm, "int")) {
    object *res = alloc(sizeof(object));
    res->type = OBJLST;
    res->data.lst = cdr;
    return res;
  }
  */
  return NULL;
}

bool strequ(char *lhs, char *rhs) {
  return memequ(lhs, rhs, strlen(lhs));
}

uint_fast8_t strlen(char *str) {
  /*
  char *bgn = str;
  while (*str)
    str++;
  return str - bgn;
  */
  
  // saves 1 byte
  char *bgn = str;
  __asm__ (
    "xor %%ax, %%ax\n"
    "repne scasb"
    : "+S" (str)
    :
    : "ax", "cc"
  );
  return str - bgn;
}

bool memequ(char *lhs, char *rhs, uint_fast8_t len) {
  /*
  while (len > 0) {
    if (*lhs != *rhs)
      return false;
    len--;
  }
  return true;
  */
  
  // saves 11 bytes
  bool res = 0;
  __asm__ (
    "repe cmpsb\n"
    : [res] "=@cce" (res)
    : "S" (lhs), "D" (rhs), "c" (len)
    : "cc"
  );
  return res;
}
