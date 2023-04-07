#include "scheduler.h"

void Scheduler::populate_queue(vector<const Action *> actions){
    for (auto action : actions){
        ActionNode *node = new ActionNode(action);
        queue.push(node);

        if (action->operation_type == OPERATIONTYPE_WRITE){
            if (transaction_writes.find(action->trans_id) == transaction_writes.end())
                transaction_writes.emplace(action->trans_id, unordered_set<string>{});

            transaction_writes[action->trans_id].insert(action->object_id);
        }
    }
}

void Scheduler::insert_node_into_schedule(ActionNode *node){
    this->current_execution_time = max(node->action->time_offset, this->current_execution_time);
    node->exec_time = this->current_execution_time;
    this->current_execution_time += 1;

    this->nodes.push_back(node);
}

string Scheduler::to_string(){
    sort( // sort the actions
        nodes.begin(),
        nodes.end(),
        [](const ActionNode *a, const ActionNode *b)
        {
            return a->exec_time < b->exec_time; // when printing we want to return the nodes sorted on exect
        });

    string res = get_schedule_name() + "\n";

    for (auto node : nodes){
        res += node->to_string() + "\n";
    }

    return res;
}


void Scheduler::print_queue(){
    cout << "QUEUE " << endl;
    vector<ActionNode *> arr;
    while (!queue.empty())
    {
        arr.push_back(queue.top());
        cout << queue.top()->to_string() << endl;
        queue.pop();
    }

    for (auto node : arr)
        queue.push(node);
        
    cout << endl;
}