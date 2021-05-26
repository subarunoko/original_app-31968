class Language < ActiveHash::Base
  self.data = [
      {id: 0, name: "---"},
      {id: 1, name: 'C/C++'}, 
      {id: 2, name: 'C#'},
      {id: 3, name: 'CSS'},
      {id: 4, name: 'GO'},
      {id: 5, name: 'HTML'}, 
      {id: 6, name: 'Java'},
      {id: 7, name: 'JavaScript'}, 
      {id: 8, name: 'Kotlin'}, 
      {id: 9, name: 'PHP'},
      {id: 10, name: 'Python'},
      {id: 11, name: 'R'}, 
      {id: 12, name: 'Ruby'},
      {id: 13, name: 'Scala'},
      {id: 14, name: 'Swift'}, 
      {id: 15, name: 'Visual Basic'}, 
      {id: 16, name: 'その他'}
  ]

  include ActiveHash::Associations
  has_many :profiles

end