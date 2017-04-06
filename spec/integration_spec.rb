require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('adding a new list', {:type => :feature}) do
    it('allows a user to click a list to see the tasks and details for it') do
        visit('/')
        # click_link('Add New List')
        fill_in('name', :with =>'Moringaschool Work')
        click_button('Add list')
        expect(page).to have_content('Success!')
    end
end

describe('viewing all of the lists', {:type => :feature}) do
    it('allows a user to see all of the lists that have been created') do
        list = List.new({:name => 'Moringaschool Homework'})
        list.save()
        visit('/')
        click_link('View All Lists')
        expect(page).to have_content(list.name)
    end
end

describe('seeing details for a single list', {:type => :feature}) do
    it('allows a user to click a list to see the tasks and details for it') do
        test_list = List.new({:name => 'School stuff'})
        test_list.save()
        test_task = Task.new({:description => "learn SQL", :list_id => test_list.id()})
        test_task.save()
        visit('/lists')
        click_link(test_list.name())
        expect(page).to have_content(test_task.description())
    end
end

describe('adding tasks to a list', {:type => :feature}) do
    it('allows a user to add a task to a list') do
        test_list = List.new({:name => 'School stuff'})
        test_list.save()
        visit("/lists/#{test_list.id()}")
        fill_in("Description", {:with => "Learn SQL"})
        click_button("Add task")
        expect(page).to have_content("Success")
    end

    describe("#update") do
        it("lets you update lists in the database") do
            list = List.new({:name => "Moringa School stuff", :id => nil})
            list.save()
            list.update({:name => "Homework stuff"})
            expect(list.name()).to(eq("Homework stuff"))
        end
    end

    describe("#delete") do
        it("lets you delete a list from the database") do
            list = List.new({:name => "Moringa School stuff", :id => nil})
            list.save()
            list2 = List.new({:name => "House stuff", :id => nil})
            list2.save()
            list.delete()
            expect(List.all()).to(eq([list2]))
        end

        it("deletes a list's tasks from the database") do
            list = List.new({:name => "Moringa School stuff", :id => nil})
            list.save()
            task = Task.new({:description => "learn SQL", :list_id => list.id()})
            task.save()
            task2 = Task.new({:description => "Review Ruby", :list_id => list.id()})
            task2.save()
            list.delete()
            expect(Task.all()).to(eq([]))
        end
    end
end
